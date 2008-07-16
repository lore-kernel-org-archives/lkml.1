Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbYGPNlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbYGPNlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 09:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbYGPNlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 09:41:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:49396 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606AbYGPNle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 09:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=CkYHl4xsNMRIITTtKCoGnI5RjJ9VO2xXx15zmcy7Us+82RXQw46xjCgdFyqI7YDTbm
         0NNVJjg8og7HiKP6nvgG1Bo89AFxgZc/5Lf79qVV+1i7lZMVYWdP9Fuq5dMN6AIt6GNK
         g9iJ9OtHDueelJ+9ggvn8dZpG4g/SxeI/2f/Q=
Message-ID: <84144f020807160641u32dac56fq9b9a30f6e32a27ca@mail.gmail.com>
Date: Wed, 16 Jul 2008 16:41:33 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: jacliburn@bellsouth.net
Subject: Re: sendfile() broken with 2.6.26 + Apache 2 ?
Cc: "Eric Dumazet" <dada1@cosmosbay.com>, "Ian Jeffray" <ian@jeffray.co.uk>,
       linux-kernel@vger.kernel.org,
       "Linux Netdev List" <netdev@vger.kernel.org>, csnook@redhat.com,
       jeff@garzik.org
In-Reply-To: <487DF9EC.9060202@bellsouth.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <487CD7A7.2080800@jeffray.co.uk> <487D893A.5080207@cosmosbay.com>
	 <487DA388.3030104@jeffray.co.uk> <487DBA74.3090800@cosmosbay.com>
	 <487DF9EC.9060202@bellsouth.net>
X-Google-Sender-Auth: aef028f020b57d47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 4:38 PM, J. K. Cliburn <jcliburn@gmail.com> wrote:
>> Yes, maybe related to commit 9d90fb1ac9d97da86e24d9ea947bf2a2f333829a
>> In this patch, Jay Cliburn enabled TSO by default for atl1 driver.
>>
>> This might be a driver problem, or a generic sendfile() problem, I dont
>> know...
>
> I'm currently traveling and unable to delve into this issue and its relation
> to the atl1 driver.  I should be able to look at it this weekend when I get
> back home.

Ehh... shouldn't we disable atl1 TSO by default for -stable, then?
