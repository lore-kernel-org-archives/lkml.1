Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbXFTWsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbXFTWsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbXFTWs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:48:28 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:22885 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbXFTWs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:48:27 -0400
Message-ID: <4679AEA7.8050806@oracle.com>
Date: Wed, 20 Jun 2007 18:48:07 -0400
From: Chuck Lever <chuck.lever@oracle.com>
Reply-To: chuck.lever@oracle.com
Organization: Oracle Corporation
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
 through other means
References: <467994BD.6000403@zytor.com> <20070620210343.GQ21478@ftp.linux.org.uk> <4679AB39.4010909@oracle.com> <4679AD0F.3040207@zytor.com>
In-Reply-To: <4679AD0F.3040207@zytor.com>
Content-Type: multipart/mixed;
 boundary="------------060600050107080507030506"
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060600050107080507030506
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

H. Peter Anvin wrote:
> Chuck Lever wrote:
>> To support NFS client performance statistics, I recently added
>> /proc/self/mountstats.  That might be a place to add details about
>> --move and --bind mounts without changing the format of /proc/mounts.
> 
> I just looked at /proc/self/mountstats; it seems to have no more
> information than /proc/self/mounts, but in an even more annoying format.
>  Either I'm missing something, this file doesn't add anything at all.

The advantage is that it doesn't have strong user space dependencies on 
its format like /proc/mounts does.

If you have NFS mount points, you will see that it includes a great deal 
of additional information about each mount.

--------------060600050107080507030506
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


--------------060600050107080507030506--
