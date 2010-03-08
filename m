Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab0CHN4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 08:56:23 -0500
Received: from smtp.turknetserver.com ([193.192.122.40]:58730 "EHLO
	smtp.turknetserver.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754022Ab0CHN4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 08:56:20 -0500
Message-ID: <4B950200.4000305@turknetserver.com>
Date: Mon, 08 Mar 2010 15:56:16 +0200
From: Tarkan Erimer <tarkan@turknetserver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-73.2 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux-2.6.33 to 33-git9 intel_drm: drm_fb_helper panic
References: <4B8FC4E1.4070509@turknetserver.com>
In-Reply-To: <4B8FC4E1.4070509@turknetserver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 04:34 PM, Tarkan Erimer wrote:
> When I booted into 2.6.33, hard lock up occurs via the following error
> message at boot time :
>
> [drm:drm_fb_helper_panic] *ERROR* panic occured,  switching back to text
> console
> BUG: scheduling while atomic: init/1/0x00000002
>
> This is a KMS enabled kernel on i945 VGA. Also, I tried (I found after
> googling a bit.)  with "i915.modeset=0 enable_mtrr_cleanup" and
> "enable_mtrr_cleanup" kernel boot options. But, still the same error
> occurs.
>
> This bug occurs on kernels from 2.6.33 to 2.6.33-git9. 2.6.33-rc8 works
> fine. My .config attached.
>
> Tarkan
>   

Anybody care to look at this issue ? BTW; it, still,  exist (tested few
mins ago.) on .33-git14, too.

Tarkan
