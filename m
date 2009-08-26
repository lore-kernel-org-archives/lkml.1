Return-Path: <linux-kernel-owner+w=401wt.eu-S1751422AbZHZTXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbZHZTXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 15:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZHZTW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 15:22:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbZHZTW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 15:22:56 -0400
Message-ID: <4A958BA0.2000801@redhat.com>
Date: Wed, 26 Aug 2009 22:23:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: alacrityvm-devel@lists.sourceforge.net,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org
Subject: Re: AlacrityVM benchmark numbers updated
References: <4A948962.7090909@gmail.com> <4A950B75.5020409@redhat.com> <4A95822D.9060207@gmail.com>
In-Reply-To: <4A95822D.9060207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2009 09:42 PM, Gregory Haskins wrote:
> Actually, I have already look at this and it does indeed seem better to
> use switch_mm+gupf() over gup() by quite a large margin.  You could then
> couple that with your DMA-engine idea to potentially gain even more
> benefits (though probably not for networking since most NICs have their
> own DMA engine anyway).
>
>    

For tx, we'll just go copyless once we plumb the destructors properly.  
But for rx on a shared interface it is impossible to avoid the copy.  
You can only choose if you want it done by the cpu or a local dma engine.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

