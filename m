Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332Ab0A0Wab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab0A0Wab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 17:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318Ab0A0Waa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 17:30:30 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:37600 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315Ab0A0Wa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 17:30:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=LFsTFQloQoftIIflT2sY82KPVGI+7bqabFw6TQK1eIkbbkSvJkCKvv3hA+hoVrn1aL
         6unSEdQQs7gDI1N0unGJx5Ap9ueENAZiiLdb3vordJC5hVcm/aUXFsHhoHnIjyN0eQWK
         spurAuY5RUBNCQpt4uuqdv2yI88H3mZuIKrP4=
Message-ID: <4B60BE7F.8070304@gmail.com>
Date: Wed, 27 Jan 2010 23:30:23 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, zhenyuw@linux.intel.com,
       yakui.zhao@intel.com
Subject: Re: i915: gpu wedged [was: mmotm 2010-01-15-15-34 uploaded]
References: <201001152359.o0FNxVne006113@imap1.linux-foundation.org>	<4B5AF1E5.1070304@gmail.com> <20100127142400.5657a7fe.akpm@linux-foundation.org>
In-Reply-To: <20100127142400.5657a7fe.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 11:24 PM, Andrew Morton wrote:
>> and kernel says:
>> [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
>> render error detected, EIR: 0x00000000
>> [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5
>> (awaiting 153151 at 153150)
>> [drm:i915_gem_execbuffer] *ERROR* i915_gem_do_execbuffer returns -5
>>
>>
>> >From <debugfs>/dri/0/i915_wedged, the GPU is wedged.
>>
> 
> umph.  There isn't much I can do about that, really.  Apart from
> fervently hoping that this known regression doesn't turn up in
> 2.6.34-rc1.

Ah, it is known. I apparently googled for a wrong line :).

Thanks for the clue,
-- 
js
