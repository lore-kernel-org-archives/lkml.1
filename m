Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbYFVULr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbYFVULr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 16:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbYFVULj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 16:11:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:63741 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbYFVULj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 16:11:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=G+NHTuREa47CQApneo8f6BFdPBC/9vRkodHVYvf6XSRGp6GZ0bD3D00Fn1tphyFyC7
         HBOa/0IXbnC2VWzFljkDDRDtmEmGrZ5PxyOReaXRLfTQoK9Q0hBenoD3LyGjYQ7ulBaT
         OLixl7noSM9DddN8DSKXg+BZSbvEiRe6FxxIY=
Message-ID: <86802c440806221311q5a65cdb6me24b45de5657359c@mail.gmail.com>
Date: Sun, 22 Jun 2008 13:11:38 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bernhard Walle" <bwalle@suse.de>
Subject: Re: [PATCH 3/3] Limit E820 map when a user-defined memory map is specified
Cc: x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com
In-Reply-To: <20080622215635.7a0ebaae@kopernikus.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213977420-1555-1-git-send-email-bwalle@suse.de>
	 <1213977420-1555-4-git-send-email-bwalle@suse.de>
	 <86802c440806201334s30cbc685se44326812841fdd2@mail.gmail.com>
	 <20080622215635.7a0ebaae@kopernikus.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 12:56 PM, Bernhard Walle <bwalle@suse.de> wrote:
> * "Yinghai Lu" <yhlu.kernel@gmail.com> [2008-06-20 13:34]:
>>
>> any problem that you encountered without this patch?
>
> Sorry, forgot to answer that question.
>
> Yes, if you use mem=3G and take a dump, kexec builds the ELF core
> headers for the full memory size, which means that the dump is as large
> as the physical memory of the machine is, which doesn't make sense.

can we use e820_update_range instead? so e820_setup_gap still can get
correct value?

YH
