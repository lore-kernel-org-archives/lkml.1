Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773Ab0ALL24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab0ALL24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 06:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745Ab0ALL2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 06:28:55 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:40256 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab0ALL2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 06:28:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=edH3wC+KqOEfsScDhWwhEvdQxQpzrw5rCDu0NvJpBZKgpJxMRkOZOWw1QJVaCVXhoq
         Z3fYxTImY3JMMo0T4tvg+AQ7bMxqBooDy/6i1qvor5fM3UzAJgLNY665jhsZbnCX/614
         QXqqK3UwSPFRQVEp/Q/5TBHcQys0tX+C2ooCc=
Message-ID: <4B4C5CEF.5060601@gmail.com>
Date: Tue, 12 Jan 2010 12:28:47 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-16.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: mchehab@redhat.com, hverkuil@xs4all.nl, ivtv-devel@ivtvdriver.org,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] media: video/cx18, fix potential null dereference
References: <1263113806-7532-1-git-send-email-jslaby@suse.cz> <1263253709.4116.1.camel@palomino.walls.org>
In-Reply-To: <1263253709.4116.1.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2010 12:48 AM, Andy Walls wrote:
> On Sun, 2010-01-10 at 09:56 +0100, Jiri Slaby wrote:
>> Stanse found a potential null dereference in cx18_dvb_start_feed
>> and cx18_dvb_stop_feed. There is a check for stream being NULL,
>> but it is dereferenced earlier. Move the dereference after the
>> check.
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> 
> Reviewed-by: Andy Walls <awalls@radix.net>
> Acked-by: Andy Walls <awalls@radix.net>

You definitely know the code better, have you checked that it can happen
at all? I mean may demux->priv be NULL?
