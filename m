Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbXCPIxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbXCPIxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbXCPIxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:53:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:44779 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451AbXCPIw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:52:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VzRQzKRCeKIvEXos+0c4JMnccsDljfsNKrIqvGXQJ9kroJJGYktxmAx3UcFFetVBoUN4D99S3nTCjoiM6up+lBvBNWAT2kE3vzBsi3WaHrp8zqpZOztVu4OVBwBzHTOMGXSMY1cpOaUw81gYVTE2hi251K2dxWyc+K5tR1CIle4=
Message-ID: <84144f020703160152h61439b28i9e438238567a4ba0@mail.gmail.com>
Date: Fri, 16 Mar 2007 10:52:54 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 1/3] revoke: misc fixes
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <45FA4C59.1000908@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703160916430.14651@sbz-30.cs.Helsinki.FI>
	 <45FA458C.8050605@yahoo.com.au>
	 <Pine.LNX.4.64.0703160927240.14902@sbz-30.cs.Helsinki.FI>
	 <45FA4984.9000506@yahoo.com.au>
	 <Pine.LNX.4.64.0703160943460.15253@sbz-30.cs.Helsinki.FI>
	 <45FA4C59.1000908@yahoo.com.au>
X-Google-Sender-Auth: b02a31fc35645792
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> Also, a down_write_trylock attempt inside i_mmap_lock should be a valid
> optimisation.

I am not sure what you're thinking here. down_write_trylock acquires
->mmap_sem which can deadlock with ->i_mmap_lock, no?
