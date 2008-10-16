Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbYJPH1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbYJPH1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 03:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbYJPH1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 03:27:46 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:3355 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbYJPH1p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 03:27:45 -0400
Message-Id: <48F70941.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Thu, 16 Oct 2008 08:28:33 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "Chris Lalancette" <clalance@redhat.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH]: Fix Xen domU boot with batched	
	 mprotect
References: <48F5CE10.3060403@redhat.com> <48F6274D.76E4.0078.0@novell.com>
 <48F61919.2050005@goop.org>
In-Reply-To: <48F61919.2050005@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 15.10.08 18:23 >>>
>>  But
>> performance-wise, CONFIG_HIGHPTE sucks under Xen anyway, so you'd
>> better not turn this on in the first place. We may want/need to provide
>> a means to disable this at run time so the same kernel when run natively
>> could still make use of it, but without impacting performance under Xen.
>>   
>
>That's a secondary issue.  What's the source of the performance hit?  
>Just all the extra kmap_atomic operations?

Yes, afaict.

