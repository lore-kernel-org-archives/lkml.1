Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbYGASVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbYGASVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbYGASVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:21:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:15737 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbYGASVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:21:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VyVij3OVrAVcBbc5mReLbnQokySSovzK8mgO++bgO3Jeg8cRojfzNKrPsAe6idIIcn
         cLznG21a5iFmBHSRPf1cbiKB9pIEMRYKkmVnZVcHh9exc1DbwqoC40tQAQKAExe3VhZK
         g3tEX1OasFuM/v59bX1WBj0WY93fwzlE0KZWQ=
Message-ID: <486A83C1.9090803@gmail.com>
Date: Tue, 01 Jul 2008 21:21:37 +0200
From: Dotan Barak <dotanba@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [RFC PATCH] - scripts/CodingStyle_sizeof -
 standardize sizeof and [PATCH] drivers/infiniband - standardize sizeof(foo)
References: <1214930986.26073.40.camel@localhost> <adar6adcwss.fsf@cisco.com>
In-Reply-To: <adar6adcwss.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> This seems like needless churn to me.  I personally prefer to see
> "sizeof foo" instead of "sizeof(foo)", since sizeof is not a function,
> and in any case I don't see much value in making this type of trivial
> change.
>   
In the IB stack i noticed all of the variations of sizeof:
sizeof foo
   or
sizeof(foo)
   (and i think that i even saw)
sizeof (foo)


IMHO, Changing all of the instances of "sizeof" from all of the 
variations to a unified one can make
the code look a little bit better ...

Dotan
