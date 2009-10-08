Return-Path: <linux-kernel-owner+w=401wt.eu-S932848AbZJHRXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848AbZJHRXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 13:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932821AbZJHRXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 13:23:06 -0400
Received: from adelie.canonical.com ([91.189.90.139]:32810 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932817AbZJHRXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 13:23:05 -0400
Message-ID: <4ACE1FD1.6070400@canonical.com>
Date: Thu, 08 Oct 2009 10:22:25 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [TOMOYO #16 03/25] LSM: Pass original mount flags to security_sb_mount().
References: <20091004124946.788396453@I-love.SAKURA.ne.jp> <20091004125327.997524942@I-love.SAKURA.ne.jp>
In-Reply-To: <20091004125327.997524942@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> This patch allows LSM modules to determine based on original mount flags
> passed to mount(). A LSM module can get masked mount flags (if needed) by
>
>	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
>		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
>		   MS_STRICTATIME);

This looks good, and would also have use in AppArmor.
