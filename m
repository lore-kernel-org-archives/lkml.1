Return-Path: <linux-kernel-owner+w=401wt.eu-S1759031AbZJHRLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031AbZJHRLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 13:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758986AbZJHRLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 13:11:05 -0400
Received: from adelie.canonical.com ([91.189.90.139]:54579 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758783AbZJHRLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 13:11:04 -0400
Message-ID: <4ACE1CFE.3020507@canonical.com>
Date: Thu, 08 Oct 2009 10:10:22 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [TOMOYO #16 01/25] LSM: Add security_path_chmod() and security_path_chown().
References: <20091004124946.788396453@I-love.SAKURA.ne.jp> <20091004125327.105675949@I-love.SAKURA.ne.jp>
In-Reply-To: <20091004125327.105675949@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> This patch allows pathname based LSM modules to check chmod()/chown()
> operations. Since notify_change() does not receive "struct vfsmount *",
> we add security_path_chmod() and security_path_chown() to the caller of
> notify_change().
>
> These hooks are used by TOMOYO.

This hooks would be useful for AppArmor as well.

