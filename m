Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbZCXK17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbZCXK17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 06:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbZCXK1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 06:27:48 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:37803 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757525AbZCXK1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 06:27:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=J53oERgt/iEMpSNGRxmsQtnRCeosKtYQpP8TTX6b6INaUKdQlphoahH6+Yyqk7MUbUVeowP+R+/Jwuav0yXeSqJ3jcSVbkDgLx+5WdF7p+JuMUthXx5vxXKqcPzf1q9tmni0mkPhdCl0epD5B8ILeEfcx6CQHgD/Guh3OvEec38=  ;
X-YMail-OSG: wKc.0N8VM1mGXaHWP3EctOhW8z2yLA43d9ITyl9VogL231Ub.3M7KIAHG1kCR.lXZvibpAo3OshMIj1lTthfguEVwT9EnJT1Nzr1zq2lLQis.VF6NFgTFHFnRT2jz10.4dfvopiaDWEAKDXw7f8BK96sizfXSDXzLwK11NCjaUTHCjZyR6T.spVmI.8OqQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jan Kara <jack@suse.cz>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
Date: Tue, 24 Mar 2009 21:27:35 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: "Martin J. Bligh" <mbligh@mbligh.org>, linux-ext4@vger.kernel.org,
       Ying Han <yinghan@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-mm" <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com> <20090319164638.GB3899@duck.suse.cz> <200903241844.22851.nickpiggin@yahoo.com.au>
In-Reply-To: <200903241844.22851.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903242127.36541.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 March 2009 18:44:21 Nick Piggin wrote:

> I close my eyes and pick something out of a hat. a686cd89. Search for XXX.
> Nice. Whether or not this cased the problem, can someone please tell me
> why it got merged in that state?

Actually I must be wrong about this if the problem was reproduced in
2.6.18. Question still stands, though.

