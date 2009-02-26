Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbZBZJyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbZBZJyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 04:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbZBZJyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 04:54:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54224 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbZBZJye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 04:54:34 -0500
Message-ID: <49A666D6.7090402@redhat.com>
Date: Thu, 26 Feb 2009 11:54:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm x86: release time_page on vcpu destruction
References: <1235574511-4571-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1235574511-4571-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Not releasing the time_page causes a leak of that page or the compound
> page it is situated in.
>   

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

