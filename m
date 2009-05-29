Return-Path: <linux-kernel-owner+w=401wt.eu-S1762312AbZE2P7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762312AbZE2P7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761701AbZE2P65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:58:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:3248 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760699AbZE2P64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:58:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=sh3EA5AEw/YTJq0QNZe7riubCiOAcAnp7W7UKS+9cXAQXdpgpoGI6h/AKtv3Xs398s
         k3VQN/eEok22zojQbMgsmXYVppeNDavUw1lP9u99F144kgGPlL+OgvGXGy8fk4zcl4yR
         V1if6tzLsXe6cpQU54HgyIC6B17ke1PAQDtuw=
Message-ID: <4A200605.4050003@gmail.com>
Date: Fri, 29 May 2009 17:57:57 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1pre) Gecko/20090525 SUSE/3.0b2-10.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: mingo@elte.hu, x86@kernel.org, linux-kernel@vger.kernel.org,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 3/3] trace: events_filter, fix lock imbalances
References: <1243497289-18591-1-git-send-email-jirislaby@gmail.com> <1243497289-18591-3-git-send-email-jirislaby@gmail.com> <4A1F36E4.9000007@cn.fujitsu.com>
In-Reply-To: <4A1F36E4.9000007@cn.fujitsu.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2009 03:14 AM, Li Zefan wrote:
> Jiri Slaby wrote:
>> apply_event_filter and apply_subsystem_event_filter omits an unlock
>> on one fail path each. Fix that.
> 
> Thanks, but this has been fixed.

Ok, sorry, I didn't notice.
