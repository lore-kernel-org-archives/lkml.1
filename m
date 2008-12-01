Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYLAVEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYLAVEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 16:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYLAVE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 16:04:28 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:7731 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYLAVE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:04:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=kgBfvpKBovRg49z/Ep6hY83rvZpU90KgeGQAjZC9AOGBdJz1m633l+9eO5H+A5Qm7i
         VHBO8xN2ZTioKz5ll3JakAogJqk9rubBqZbcdpNmf3ue6aM1EbNQJqqNMrkraNs+AA8Q
         4ph/wxe+2d2yAz0xOLQRQ02sgGuzcNaWHJeAI=
Message-ID: <b6c5339f0812011304h15eade93kada95b6616a2ddd@mail.gmail.com>
Date: Mon, 1 Dec 2008 16:04:25 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Jan Kara" <jack@suse.cz>
Subject: Re: [PATCH] udf: fix sparse warnings
Cc: "Hannes Eder" <hannes@hanneseder.net>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, trivial@kernel.org
In-Reply-To: <20081201120951.GD17303@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <493049b5.170e660a.26c3.ffff8fd8@mx.google.com>
	 <20081201120951.GD17303@duck.suse.cz>
X-Google-Sender-Auth: 4baaeaeac965a9f8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2008 at 7:09 AM, Jan Kara <jack@suse.cz> wrote:
> From f3facf9a4a60bba9f1fa0c779fc441c6aff90eb4 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Mon, 1 Dec 2008 13:06:10 +0100
> Subject: [PATCH] udf: fix sparse warnings:
[...]
> -       } else {
> -               return;
> +               udf_table_free_blocks(sb, inode, map->s_fspace.s_table,
> +                                     bloc, offset, count);
>        }
> +       return;
>  }

Harmless, but in this case you don't need the return at all.

-- 
Bob Copeland %% www.bobcopeland.com
