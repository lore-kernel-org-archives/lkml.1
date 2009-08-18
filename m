Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbZHRMiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbZHRMiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 08:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbZHRMiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 08:38:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53003 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbZHRMiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 08:38:50 -0400
Message-ID: <4A8AA0C6.805@redhat.com>
Date: Tue, 18 Aug 2009 15:38:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Gregory Haskins <GHaskins@novell.com>
CC: mingo@elte.hu, gregory.haskins@gmail.com,
       alacrityvm-devel@lists.sourceforge.net, mst@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model
References: <4A8A67ED0200005A000528F5@sinclair.provo.novell.com> <4A8A67F70200005A000528F8@sinclair.provo.novell.com> <4A8A67F70200005A000528F8@sinclair.provo.novell.com>
In-Reply-To: <4A8A67F70200005A000528F8@sinclair.provo.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2009 03:36 PM, Gregory Haskins wrote:
> Yeah, I agree.  I am not advocating we expend energy on this now.  But my thoughts at the time were that that particular problem can be solved at io-setup time with some kind of call to qualify the address.
>
> Iow: a slow path call with the address would return flags on whether iowrite() should do a real io, or a IOoHC.
>    

Yes, it could work, though we'd need somewhere to stow this 
information.  IIRC Arnd suggested a bit from the address itself.

-- 
error compiling committee.c: too many arguments to function

