Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbZKIVdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbZKIVdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 16:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbZKIVdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 16:33:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42313 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbZKIVdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 16:33:41 -0500
Message-ID: <4AF88A64.7010903@zytor.com>
Date: Mon, 09 Nov 2009 13:32:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-kernel@vger.kernel.org, device@lanana.org, rubini@vision.unipv.it,
       gregkh@suse.de, cluster-devel@redhat.com
Subject: Re: [PATCH] misc: use a proper range for minor number dynamic allocation
References: <1256340497-19320-1-git-send-email-cascardo@holoscopio.com> <20091109132836.6cf7f559.akpm@linux-foundation.org>
In-Reply-To: <20091109132836.6cf7f559.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2009 01:28 PM, Andrew Morton wrote:
> 
>> The proposed solution uses the not yet reserved range from 64 to 127. If
>> more devices are needed, we may push 64 to 16. Moreover, if we don't
>> need to give priority to the higher numbers anymore, we can start using
>> the bitmap/bitops functions.
> 
> So...  misc minors 64 to 127 are presently unused?
> 

Perhaps we should just start at 256 and go upward, or even 1048575 and
go downward.

	-hpa
