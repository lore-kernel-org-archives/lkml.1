Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbYAIBUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbYAIBUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:20:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYAIBTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:19:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56586 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbYAIBTx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:19:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Date: Wed, 9 Jan 2008 02:19:46 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       apw@shadowen.org
References: <20080108164015.GC31504@one.firstfloor.org> <200801090140.58864.arnd@arndb.de> <20080109004748.GI2117@one.firstfloor.org>
In-Reply-To: <20080109004748.GI2117@one.firstfloor.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801090219.46876.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18AdhomAB9qpd+ovJpaIlqm/h1NEV8ytW2ToAX
 AOk5kjCYDOkNx1PhrFP9jzEffTcsKr0QLeBYT/WhJzsryEFzrS
 BBpROQYtZWP3SttxeTitA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2008, Andi Kleen wrote:
> I imagined it would check for 
> 
> +struct file_operations ... = { 
> +      ...
> +       .ioctl = ...
> 
> That wouldn't catch the case of someone adding only .ioctl to an 
> already existing file_operations which is not visible in the patch context, 
> but that should be hopefully rare. The more common case is adding
> completely new operations

Right, this would work fine. We can probably even have a list of
data structures that work like file_operations in this regard.

	Arnd <><
