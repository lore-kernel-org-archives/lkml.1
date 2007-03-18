Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbXCRQNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbXCRQNG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 12:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbXCRQNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 12:13:06 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:37194 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbXCRQNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 12:13:05 -0400
From: Roman Zippel <zippel@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: PROBLEM: "Make nenuconfig" does not save parameters.
Date: Sun, 18 Mar 2007 17:12:38 +0100
User-Agent: KMail/1.9.5
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
References: <20070310160614.GB10230@cvg> <20070311100723.GA10359@cvg> <20070311195033.GA3302@uranus.ravnborg.org>
In-Reply-To: <20070311195033.GA3302@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703181712.39698.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday 11 March 2007 20:50, Sam Ravnborg wrote:

> +	sym = sym_lookup("KERNELVERSION", 0);
> +	sym_calc_value(sym);
> +	size = snprintf(menu_backtitle, sizeof(menu_backtitle),
> +	                _("%s - Linux Kernel v%s Configuration"),
> +		        config_filename, sym_get_string_value(sym));

An alternative might to only show the filename, only if explicitly set.

> +	set_config_filename(".config");

Please don't hardcode the filename, use conf_get_configname() instead.

bye, Roman
