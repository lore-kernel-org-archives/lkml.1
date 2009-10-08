Return-Path: <linux-kernel-owner+w=401wt.eu-S1758897AbZJHQkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbZJHQkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758840AbZJHQkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:40:10 -0400
Received: from mail-yx0-f181.google.com ([209.85.210.181]:57311 "EHLO
	mail-yx0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758807AbZJHQkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:40:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        b=jbAfxQ7C5zSeEylPyry0oRltYOiPZRumpJRHwLKQ8SYfG2BGPwSj8NRH0c2YGxbPoi
         wy0sfLduXo1Y5vzBC4yAqdOoS7IBNAvxN/5ylGy+Sn/pyvd0UDF/HZ7/6TPF7ZLHBEni
         5+nuNja6H8KHj/u760fL2evHYAWWND3i9TseE=
MIME-Version: 1.0
In-Reply-To: <haj8uj$fn8$2@ger.gmane.org>
References: <haj471$fn8$1@ger.gmane.org>
	 <58965d8a0910071618s2420fed1k4ccde4823e57f756@mail.gmail.com>
	 <haj8uj$fn8$2@ger.gmane.org>
Date: Thu, 8 Oct 2009 11:08:12 -0500
X-Google-Sender-Auth: f47fa6c9e76bff67
Message-ID: <58965d8a0910080908m6d914800m9465c70929eaa7ba@mail.gmail.com>
Subject: Re: iso9660 mount problem
From: Paul Hartman <paul.hartman+linux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 6:42 PM, Jack Byer <ojbyer@usa.net> wrote:
> Paul Hartman wrote:
>
>> On Wed, Oct 7, 2009 at 5:22 PM, Jack Byer <ojbyer@usa.net> wrote:
>>> I have a CD of a commercial software program that I am attempting to run
>>> under wine. The CD works without problems under Windows, but when I mount
>>> it on linux the file system appears to be empty (no files or
>>> directories). The drive is capable of reading the CD because "strings
>>> /dev/cdrom" works.
>>>
>>> What would I need to do in order to troubleshoot this problem?
>>
>> Maybe try mounting with the "-o unhide" option. Or maybe it is a
>> multi-session disc?
>
> -o unhide does not help. Can a factory-pressed disc be multisession? It's
> not a CD-R

Yes (for example "Enhanced CDs" which contain both audio and data
tracks). I think the default on MS Windows is to mount the last
session on the disc. You should be able to use mount paramater "-o
session=x" with x being the session number you want to mount.
