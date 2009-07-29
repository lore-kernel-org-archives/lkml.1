Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbZG2UFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbZG2UFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 16:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZG2UE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 16:04:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43700 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZG2UE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 16:04:59 -0400
Message-ID: <4A70AA64.4020301@zytor.com>
Date: Wed, 29 Jul 2009 13:00:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
CC: linux@arm.linux.org.uk, alain@knaff.lu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 5/5] Add support for LZO-compressed kernels on x86
References: <1248271279-9920-1-git-send-email-albin.tonnerre@free-electrons.com> <1248271279-9920-2-git-send-email-albin.tonnerre@free-electrons.com> <1248271279-9920-3-git-send-email-albin.tonnerre@free-electrons.com> <1248271279-9920-4-git-send-email-albin.tonnerre@free-electrons.com> <1248271279-9920-5-git-send-email-albin.tonnerre@free-electrons.com>
In-Reply-To: <1248271279-9920-5-git-send-email-albin.tonnerre@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2009 07:01 AM, Albin Tonnerre wrote:
> This is the third and last part of the patch, which contains the
> necessary changes to the x86 Kconfig and boot/compressed to allow the
> use of this new compression method
> 
> Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>

Acked-by: H. Peter Anvin <hpa@zytor.com>

Since the patchset otherwise isn't really x86-related it probably makes
more sense to pass this through the kbuild tree, or perhaps via akpm,
rather than -tip?

	-hpa
