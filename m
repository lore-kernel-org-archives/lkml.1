Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbZDFQuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbZDFQuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZDFQuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:50:07 -0400
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:40694 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZDFQuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:50:06 -0400
Message-ID: <49DA32B7.8080004@numericable.fr>
Date: Mon, 06 Apr 2009 18:49:59 +0200
From: Etienne Basset <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: LSM <linux-security-module@vger.kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>, linux-audit@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sgrubb@redhat.com, sds@tycho.nsa.gov
Subject: Re: [PATCH 0/2] security/smack implement logging V2
References: <49D86FFA.1010507@numericable.fr> <1239032066.4009.5.camel@localhost.localdomain>
In-Reply-To: <1239032066.4009.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> On Sun, 2009-04-05 at 10:46 +0200, Etienne Basset wrote:
> 
>> the following 2 patches implements auditing of security events for Smack.
>> It tries to implement what Eric Paris suggested, and moves shareable code
>> to include/linux/lsm_audit.h and security/lsm_audit.c.
>> Smack specific logging functions are now defined in smack_access.c
> 
> 
>> type=1400 audit(1238919813.116:21): SMACK[smack_inode_getattr]: action=denied subject="FOO" object="etienne" requested=r pid=6679 comm="bash" path="/home/etienne/Desktop" dev=sda8ino=1237000
> 
> Can we make SMACK[smack_inode_getarr] into key=value pairs too and get
> rid of that extra ':'?  Anyone have naming suggestions?
> 
> lsm=SMACK function=smack_inode_getattr
> 
yes, sure. Maybe just :
lsm=SMACK fn=smack_inode_getattr
I want as much info as possible with as less characters as possible (is this english? :) )

> also: dev=sda8ino=1237000  I'm guessing that was just a typo of you
> putting the example into the e-mail, but you may want to double check.
> 
yeah, bad cut&paste, sorry about that

Etienne

