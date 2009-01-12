Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbZALSUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbZALSUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZALSUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:20:00 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:58677 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbZALST7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:19:59 -0500
Message-ID: <496B899E.7060605@oracle.com>
Date: Mon, 12 Jan 2009 10:19:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       sfrench@samba.org, Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for January 12 (cifs vs. staging)
References: <20090112154539.4857f533.sfr@canb.auug.org.au>
In-Reply-To: <20090112154539.4857f533.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.496B89A2.00CF:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Some people took me at my word and so we have the 2.6.30 code starting to
> trickle in already.



When CIFS is built-in (=y) and staging/rt28[67]0 =y, there are multiple
definitions of:

build-r8250.out:(.text+0x1d8ad0): multiple definition of `MD5Init'
build-r8250.out:(.text+0x1dbb30): multiple definition of `MD5Update'
build-r8250.out:(.text+0x1db9b0): multiple definition of `MD5Final'

all of which need to have more unique identifiers for their global
symbols (e.g., rt28_md5_init, cifs_md5_init, foo, blah, bar).


-- 
~Randy
