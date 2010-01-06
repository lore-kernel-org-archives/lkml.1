Return-Path: <linux-kernel-owner+w=401wt.eu-S932311Ab0AFQxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab0AFQxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 11:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932286Ab0AFQxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 11:53:40 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:53434 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab0AFQxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 11:53:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=R4uswxMbWCnsc6Mr+8pkUpiHhr4htl4UU2cN7HNxMz5YqsmW5c8+MX+QTonKT/UVuS
         xmcbD2hwUHtUVAq4OUVjhsnkGvPwDaLntBK5ujXqV23yRzXCcmXnxrljcnZwCSKAfB4Y
         dshi8tnHxXjjqyH62LfghErhWG8BUQjcQAPMU=
Message-ID: <4B44C00A.4080603@gmail.com>
Date: Wed, 06 Jan 2010 17:53:30 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-16.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] media: video/tuner-core, fix memory leak
References: <1262796476-17737-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1262796476-17737-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2010 05:47 PM, Jiri Slaby wrote:
> Stanse found a memory leak in tuner_probe. t is not
> freed/assigned on all paths. Fix that.

Oops. I generated two patches here, only the second is for PCI.

Sorry Mauro, you got this one twice.

-- 
js
