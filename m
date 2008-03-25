Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbYCYJbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbYCYJbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 05:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYCYJbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 05:31:12 -0400
Received: from n14.bullet.mail.mud.yahoo.com ([68.142.206.41]:46322 "HELO
	n14.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751873AbYCYJbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 05:31:11 -0400
X-Yahoo-Newman-Id: 28759.90980.bm@omp415.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=MFhhyRVmuklQv0RIi+OaUon2MJxbVv+1xa/Kk8CojpY9Kvv2a+iRwwK0/3Ljj1zIV7x5zdX42IJnnZj4hCsHKue1R0Pr60unbNpKYgIeFGAQaIqJ5ytk3wyRfRq2l3yMNnAAdOBkORTtUXS0FuDU7ob7oZoixkUAZdfOpRz2muM=  ;
X-YMail-OSG: VHAkJr8VM1m6k5muxawsdgwqUpP8.TsRhjO3xrVtaNKPu14KKxSmEJjD2Ra5bcY84ZDG5AlkDA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Dmitri Monakhov <dmonakhov@openvz.org>, akpm@linux-foundation.org
Subject: Re: [PATCH] Fix data leak in nobh_write_end.
Date: Tue, 25 Mar 2008 20:22:48 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20080320122953.GA19928@dmon-lap.sw.ru> <20080320123916.GA19995@dmon-lap.sw.ru>
In-Reply-To: <20080320123916.GA19995@dmon-lap.sw.ru>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803252022.48730.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 March 2008 23:39, Dmitri Monakhov wrote:
> On 15:29 Thu 20 Mar     , root wrote:
> Opps.. sorry for incorrectly filled "FROM:" filed, email was from me.

Thanks for finding this. I guess it was a thinko as to the semantics
of PageMappedToDisk on my behalf...

Reviewed-by: Nick Piggin <npiggin@suse.de>

