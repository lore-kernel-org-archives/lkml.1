Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbZGCVV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbZGCVV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 17:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbZGCVVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 17:21:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46085 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472AbZGCVVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 17:21:48 -0400
Message-ID: <4A4E765F.4000501@redhat.com>
Date: Fri, 03 Jul 2009 23:21:35 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH] xen: wait up to 5 minutes for device connection
References: <1246626771-11345-1-git-send-email-pbonzini@redhat.com> <20090703160046.GA4262@infradead.org>
In-Reply-To: <20090703160046.GA4262@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/09 18:00, Christoph Hellwig wrote:
> On Fri, Jul 03, 2009 at 03:12:51PM +0200, Paolo Bonzini wrote:
>> Increases the device timeout from 10s to 5 minutes, giving the user a visual
>> indication during that time in case there are problems.  The patch is a
>> backport of changesets 144, 146, 150 and 909 in the Xenbits tree.
>
> Why would it take 5 minutes to wait for a device?

Usually it is *much* faster, but when the host is quite loaded it can 
take a unusual long time.  With 10 seconds it happends in practice now 
and then that a virtual machine fails to boot just because the virtual 
root disk didn't show up fast enough.

cheers,
   Gerd
