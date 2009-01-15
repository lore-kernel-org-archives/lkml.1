Return-Path: <linux-kernel-owner+w=401wt.eu-S1761782AbZAOSHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761782AbZAOSHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 13:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764248AbZAOSGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 13:06:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62712 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764076AbZAOSGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 13:06:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Philippe De Muyter <phdm@macqel.be>
Subject: Re: linux kernel without file system
Date: Thu, 15 Jan 2009 19:06:42 +0100
User-Agent: KMail/1.9.9
Cc: Rogan Dawes <lists@dawes.za.net>, Xavier Bestel <xavier.bestel@free.fr>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <496DA678.1090701@wpkg.org> <496DFD45.5030408@dawes.za.net> <20090114152423.GA24562@frolo.macqel>
In-Reply-To: <20090114152423.GA24562@frolo.macqel>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151906.43701.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18vKVKumu65S4NxFiiQ/9TSgQaPwNiygFvlidX
 EOE0fZpmSm3FrK9IVAzRtjesdvtjshWEE3BBYoUrGu72AeQuVi
 D9IVY2ogjNv3AWxZg1q5g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 January 2009, Philippe De Muyter wrote:
> if possible, mcf52236 (256k flash 32k sram in chip) :)
> 
> kernel+uapplication XIP in flash
> 
> they seems to push something called utasker

In 256kb it will be hard to even support simple user space.
One solution might be to just use linux as a library and
implement your application code in the kernel, inside
of the . That lets you throw out all system calls and some
of the init code of the kernel (don't call rest_init).

At that stage, you have lost most of the advantages of
using Linux over some other kernel.

	Arnd <><
