Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbZL3U6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbZL3U6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZL3U6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:58:37 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:44321 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbZL3U6g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:58:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SUXxQLI45kzsnsb55O1UlZ0l/k99qHN0ICLloJgK5clXsZFXfdR1uuQ3TeIiR+UTW8
         h0GY5KE4sm/Zq3GOgXndGsDuDcYIeRQB4/Ts9JObm2XtSfp7GtyXqZqAWb/muWME2I2h
         kC2qzUqlDtG6uiss1LWXdhwuPihb6VNiFNPr0=
MIME-Version: 1.0
In-Reply-To: <20091230195555.GA5367@fancy-poultry.org>
References: <200912301900.29578.mboton@gmail.com>
	 <20091230195555.GA5367@fancy-poultry.org>
Date: Wed, 30 Dec 2009 21:58:33 +0100
X-Google-Sender-Auth: 71bcbc260a088726
Message-ID: <1e7b68c40912301258t793a9fa2n9a5648a391399858@mail.gmail.com>
Subject: Re: BFS v0.313 CPU scheduler for 2.6.32
From: =?ISO-8859-1?Q?Miguel_Bot=F3n?= <mboton@gmail.com>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 8:55 PM, Heinz Diehl <htd@fancy-poultry.org> wrote:
> On 30.12.2009, Miguel Botón wrote:
>
>> If you want to try BFS on a 2.6.33 kernel, you can try this 'unofficial' port:
>> http://git.zen-kernel.org/?p=kernel/zen.git;a=shortlog;h=refs/heads/sched-bfs
>
>> I'm currently using it with no issues so far.
>
> Your patch applies cleanly to 2.6.33-rc2, but compilation fails:
>
> [....]

Well, looks like you didn't apply the patch correctly. Your
'sched_bfs.c' is different.

Try this patch: http://omploader.org/vMzRieg/2.6.33-rc2-sched-bfs-313.patch

Greetings,

--
Miguel Botón
