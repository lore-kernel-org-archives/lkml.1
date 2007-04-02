Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbXDBRfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbXDBRfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 13:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbXDBRfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 13:35:50 -0400
Received: from terminus.zytor.com ([192.83.249.54]:44487 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbXDBRft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 13:35:49 -0400
Message-ID: <46113ED6.4060005@zytor.com>
Date: Mon, 02 Apr 2007 10:35:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "Antonino A. Daplas" <adaplas@gmail.com>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>
Subject: Re: [PATCH] vt: Do not clear UTF when resetting console
References: <46110F88.5040905@gmail.com>
In-Reply-To: <46110F88.5040905@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antonino A. Daplas wrote:
> Resetting the console, either by ANSI escape sequences or by the reset utility,
> will drop the console back to legacy (non-UTF-8) mode. Fix this by leaving the
> field vc_data.vc_utf untouched in reset_terminal(). In addition, a global
> variable (default_utf8) which defines system-wide UTF-8 setting is created.
> This variable can be adjusted via sysfs.

If you're going to introduce a system-wide default, instead of issuing 
the appropriate escape code, then I would argue it should still be 
forced (to the default) when issuing a console reset.

	-hpa
