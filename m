Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbXFTWez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbXFTWez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbXFTWeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:34:46 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:18768 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbXFTWep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:34:45 -0400
Message-ID: <4679AB39.4010909@oracle.com>
Date: Wed, 20 Jun 2007 18:33:29 -0400
From: Chuck Lever <chuck.lever@oracle.com>
Reply-To: chuck.lever@oracle.com
Organization: Oracle Corporation
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
 through other means
References: <467994BD.6000403@zytor.com> <20070620210343.GQ21478@ftp.linux.org.uk>
In-Reply-To: <20070620210343.GQ21478@ftp.linux.org.uk>
Content-Type: multipart/mixed;
 boundary="------------080302000001050300020807"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080302000001050300020807
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Al Viro wrote:
> On Wed, Jun 20, 2007 at 01:57:33PM -0700, H. Peter Anvin wrote:
>> ... or, alternatively, add a subfield to the first field (which would
>> entail escaping whatever separator we choose):
>>
>> /dev/md6 /export ext3 rw,data=ordered 0 0
>> /dev/md6:/users/foo /home/foo ext3 rw,data=ordered 0 0
>> /dev/md6:/users/bar /home/bar ext3 rw,data=ordered 0 0
> 
> Hell, no.  The first field is in principle impossible to parse unless
> you know the fs type.
> 
> How about making a new file with sane format?  From the very
> beginning.  E.g. mountpoint + ID + relative path + type + options,
> where ID uniquely identifies superblock (e.g. numeric st_dev)
> and backing device (if any) is sitting among the options...

To support NFS client performance statistics, I recently added 
/proc/self/mountstats.  That might be a place to add details about 
--move and --bind mounts without changing the format of /proc/mounts.

--------------080302000001050300020807
Content-Type: text/x-vcard; charset=utf-8;
 name="chuck.lever.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="chuck.lever.vcf"

begin:vcard
fn:Chuck Lever
n:Lever;Chuck
org:Oracle Corporation;Corporate Architecture: Linux Projects Group
adr:;;1015 Granger Avenue;Ann Arbor;MI;48104;USA
title:Principal Member of Staff
tel;work:+1 248 614 5091
x-mozilla-html:FALSE
url:http://oss.oracle.com/~cel/
version:2.1
end:vcard


--------------080302000001050300020807--
