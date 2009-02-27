Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbZB0B3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbZB0B3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 20:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbZB0B2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 20:28:54 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62799 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759880AbZB0B2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 20:28:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Glauber Costa <glommer@redhat.com>
Subject: Re: [PATCH] remove static declaration from wall clock version
Date: Fri, 27 Feb 2009 02:28:37 +0100
User-Agent: KMail/1.9.9
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
References: <1235677340-3139-1-git-send-email-glommer@redhat.com> <200902262050.27555.arnd@arndb.de> <20090227012222.GA5979@poweredge.glommer>
In-Reply-To: <20090227012222.GA5979@poweredge.glommer>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902270228.38047.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+aaqv2RV/uNOC0MsqvclSI+dX80UDFRdPl+T0
 D//tLFLQ7NCV7+2Gvl6t4442gkjXIZrpJ0/a8iQJFZVtLQyUex
 mtikf8jqCUgnH4mKnylSQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 February 2009, Glauber Costa wrote:
> 
> > Doesn't this mean that kvm_write_guest now writes an uninitialized value
> > to the guest?
> No. If you look closely, it's now initialized to 1.

Right, I didn't see that change at first.

	Arnd <><
