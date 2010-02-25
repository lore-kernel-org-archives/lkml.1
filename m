Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461Ab0BYU35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 15:29:57 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:52939 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792Ab0BYU3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 15:29:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=FFXLyfKDitIzhvIbKvbJSMvf8UM20XfYinOtTMD1XBeraP4UIsdaFFJcWJi4h99/LO
         DjbV3hdR8mJPLYYCOF550R43nxF2qrkpwje7wyuK5wUg4XmBTVG+qLfwyq1YX4TuOODh
         pNZNAAE1YHSkWaToSSZCi8hT9uMbtsLF1lAAA=
MIME-Version: 1.0
In-Reply-To: <20100225202358.GC10960@localhost.localdomain>
References: <cb0375e11002251201v7969b891n687f928e2402f7c9@mail.gmail.com> 
	<20100225202358.GC10960@localhost.localdomain>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 25 Feb 2010 15:29:34 -0500
X-Google-Sender-Auth: a57ffc2320c89c84
Message-ID: <cb0375e11002251229q2a6989c5n64d739dec4f8de44@mail.gmail.com>
Subject: Re: [2.6.33 regression] btrfs mount causes memory corruption
To: Josef Bacik <josef@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 3:23 PM, Josef Bacik <josef@redhat.com> wrote:
> On Thu, Feb 25, 2010 at 03:01:08PM -0500, Andrew Lutomirski wrote:
>> Mounting btrfs corrupts memory and causes nasty crashes within a few
>> seconds.  This seems to happen even if the mount fails (note the
>> unrecognized mount option).  This is a regression from 2.6.32, and
>> I've attached an example.
>>
>
> And it only happens when you mount a btrfs fs?  Can you show me a trace of when
> you mount a btrfs fs with valid mount options?  I'd like to see if we're not
> cleaning up something properly or what.  Thanks,

Seems OK.  Or maybe I just got lucky, but it's crashed every time I
tried to mount with 'acl' before.

I even went through a couple iterations of trying to mount with
'xattr' and 'user_xattr', both of which failed.

--Andy
