Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbZIPODE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbZIPODE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 10:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZIPODD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 10:03:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbZIPODB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 10:03:01 -0400
Message-ID: <4AB0F013.8050608@redhat.com>
Date: Wed, 16 Sep 2009 17:02:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH 0/5] Another set of Nested SVM fixes and cleanups
References: <1253107459-8967-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1253107459-8967-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2009 04:24 PM, Joerg Roedel wrote:
> Hi,
>
> this series of patches contain another set of cleanups and an important fix to
> the Nested SVM code. These patches make the TSC handling code for SVM aware of
> a nested guest. This fixes the TSC running backwards on guest and nested guest.
> The backwards running TSC resulted in stalled guests when kvm-clock was
> enabled. Please consider to apply.
>
>    

Looks good.  3, 4 needed for 2.6.32-rc as well, yes?

-- 
error compiling committee.c: too many arguments to function

