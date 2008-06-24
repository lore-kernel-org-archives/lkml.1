Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbYFXAKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbYFXAKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 20:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbYFXAJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 20:09:24 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:52910 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015AbYFXAJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 20:09:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=lJ5JX4EaShcvPxv9FzvXgdd3tNobD1s8gZ2th2hUEwL0lYwSGPXluuEU/2QCUBx5od
         3lyjMB/ZgLLfUTQ+DW2vs5KIRkMArB6GEXQi7/NM8HqB720muIlSCFFB9luXR4lbpgfX
         ODucX/PohxAKvksL/jqNOJRHrSTfndwd4FbVE=
Message-ID: <e9e943910806231709jec5056ta7494858b420b6a9@mail.gmail.com>
Date: Tue, 24 Jun 2008 01:09:19 +0100
From: "Duane Griffin" <duaneg@dghda.com>
To: "Sami Liedes" <sliedes@cc.hut.fi>
Subject: Re: [PATCH] ext3: handle corrupted orphan list at mount
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com
In-Reply-To: <20080623223238.GA8802@vipunen.hut.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080607121940.8ee6044a.akpm@linux-foundation.org>
	 <1214258200-16623-1-git-send-email-duaneg@dghda.com>
	 <20080623223238.GA8802@vipunen.hut.fi>
X-Google-Sender-Auth: f2c209404ff3540c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/23 Sami Liedes <sliedes@cc.hut.fi>:
> You people working hard to fix bugs and implement great filesystems
> almost makes me feel bad for trying to break your code :)

Not at all, it gives me something productive to do with my time! ;)

> Here I get (on x86 gcc 4.3.1):
>
> fs/ext3/ialloc.c: In function 'ext3_orphan_get':
> fs/ext3/ialloc.c:701: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'unsigned int'
>
> So it probably should be %u or something.

Thanks, fixed for the next version.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
