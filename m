Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbYFXSTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbYFXSTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 14:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYFXSTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 14:19:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:47647 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbYFXST3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 14:19:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=gNysuqmK5wPjfJ3RoKGoDhdOG06Fzkv1UdMDn8EHBSZgGwOhVqV0MZoiiuz9500B+b
         KxM+DH0YT6+qXU3/mr08uaqo3bt5W/lL6IOTiNcFY61skmc7LrXwVqWkH2vVq+/WQq1U
         hD1bos/KxixIdos8zW6nZCmWFyMf+NOEHm3NI=
Message-ID: <2f11576a0806241119h64c46b0dt251980056fc94353@mail.gmail.com>
Date: Wed, 25 Jun 2008 03:19:29 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH] fix to putback_lru_page()/unevictable page handling rework v3
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <1214329708.6563.43.camel@lts-notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080621185408.E832.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080624184122.D838.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <1214327987.6563.22.camel@lts-notebook>
	 <2f11576a0806241035p45a440e1gb798091ef39cffc8@mail.gmail.com>
	 <1214329708.6563.43.camel@lts-notebook>
X-Google-Sender-Auth: 9c979c50784cd97c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> but I still happend panic on usex and nishimura-san's cpuset migration test.
>>   -> http://marc.info/?l=linux-mm&m=121375647720110&w=2
>
> I saw the description of the cpuset migration test.  Have you wrapped
> this in a script suitable for running under usex?

Ah, no. sorry.
I use multiple console by cpuset test and usex.
