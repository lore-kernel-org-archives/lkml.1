Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408Ab0ATUCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab0ATUCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391Ab0ATUCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:02:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:49445 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab0ATUC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:02:29 -0500
Message-ID: <4B5760BA.4060903@kernel.org>
Date: Wed, 20 Jan 2010 11:59:54 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 01/37] x86: move range related operation to one file
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org> <1263611228-6751-2-git-send-email-yinghai@kernel.org> <alpine.DEB.2.00.1001191048480.22304@router.home> <4B575B68.4030809@kernel.org> <alpine.DEB.2.00.1001201350310.15175@router.home>
In-Reply-To: <alpine.DEB.2.00.1001201350310.15175@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 11:51 AM, Christoph Lameter wrote:
> On Wed, 20 Jan 2010, Yinghai Lu wrote:
> 
>>> Subtract range can now do what update_range did? How so?
>>
>> update_range was introduced at first. and actually it did sth like subtract range.
>>
>> and subtract range is more accurate.
> 
> Subtract range suggest that you may be removing the range.
> 
> subtract_from_range?

void subtract_range(struct range *range, int az, u64 start, u64 end)

struct range *range, int az : is the original range holder.

and will remove [start,  end)

