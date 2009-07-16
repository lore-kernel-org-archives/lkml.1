Return-Path: <linux-kernel-owner+w=401wt.eu-S933161AbZGPVk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161AbZGPVk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 17:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932917AbZGPVk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 17:40:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59752 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932869AbZGPVk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 17:40:57 -0400
Date: Thu, 16 Jul 2009 23:33:12 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       rpurdie@rpsys.net, lenb@kernel.org, rui.zhang@intel.com,
       corentincj@iksaif.net, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 1/3] backlight: Allow drivers to update the core, and
 generate events on changes
Message-ID: <20090716233312.3586f9a5@hammerfall>
In-Reply-To: <1247587564-27737-1-git-send-email-mjg@redhat.com>
References: <1247587564-27737-1-git-send-email-mjg@redhat.com>
Organization: Red Hat Czech
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Tue, 14 Jul 2009 17:06:02 +0100 Matthew Garrett napsal:
> +static void backlight_generate_event(struct backlight_device *bd,
> +				     enum backlight_update_reason
> reason) +{
> +	char *envp[2];
> +
> +	switch (reason) {
> +	case BACKLIGHT_UPDATE_SYSFS:
> +		envp[0] = "SOURCE=sysfs";
> +		break;
> +	case BACKLIGHT_UPDATE_HOTKEY:
> +		envp[0] = "SOURCE=hotkey";
> +		break;
> +	default:
> +		envp[0] = "SORUCE=unknown";

There's a typo here. s/SORUCE/SOURCE/

Michal
