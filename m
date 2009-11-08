Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbZKHRKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbZKHRKu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 12:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbZKHRKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 12:10:49 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:40953 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbZKHRKs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 12:10:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YWX7Vg8QoK+h7LBPPced8k3hX9d1PnjesqK9zB+SgFubp1oVrgz3N4EyzRQo+5as80
         /kzpekdf4ERi8gnRujLYRYUq4le3SpLMwhqdGwVUopV2ggPibAsWu4SnLHB7YUu/mgyC
         Zdo3LE1wvJTqP9FrfHYHEd1h/e7oROc00Sae8=
MIME-Version: 1.0
In-Reply-To: <cover.1257602781.git.andre.goddard@gmail.com>
References: <cover.1257602781.git.andre.goddard@gmail.com>
Date: Sun, 8 Nov 2009 20:02:46 +0300
Message-ID: <b6fcc0a0911080902oa28b20fi7d834fc526571b85@mail.gmail.com>
Subject: Re: [PATCH v4 00/12] introduce skip_spaces(), reducing code size plus 
	some clean-ups
From: Alexey Dobriyan <adobriyan@gmail.com>
To: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/7/09, André Goddard Rosa <andre.goddard@gmail.com> wrote:
> skip_spaces()

This is pointless wrapper and if you don't understand and immediately see
what such code does you shouldn't be allowed near kernel.

"const _ctype" patch should be fine.

It's pretty sad to see so much activity around all sorts of simple and
simultaneously
irrelevant stuff like formatting, printk, pr_debug, printk_once, loglevels etc

I suggest to kernel newbies to find and fix a bug. You'll learn much
more from this exercise.
