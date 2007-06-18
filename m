Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbXFRCSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbXFRCSk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 22:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbXFRCSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 22:18:33 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:60081 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbXFRCSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 22:18:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H4CmqrSg3KvXNqmQOJUbhuvWmM9o3l7pY6b8+Otknd0PqyDEyJOwcceOMAEh12c9OythKBKO1Oxj33ziNkyG00Vm4Rva3B8J/1gO/ZV3m3RLHUtst0VNQkbaFtOWo/s4Rl2pec7WLZzk+VTimBl1DJ5DzB0LKoq0Ut86tk6o7SY=
Message-ID: <21d7e9970706171918p19bc3b13ta747dc76d2677345@mail.gmail.com>
Date: Mon, 18 Jun 2007 12:18:32 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Carlo Wood" <carlo@alinoe.com>, "Dave Airlie" <airlied@gmail.com>,
       "Dave Jones" <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com
Subject: Re: [AGPGART] intel_agp: use table for device probe
In-Reply-To: <20070618015636.GA8561@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070617190714.GA18115@redhat.com>
	 <20070617204904.GB3430@redhat.com> <20070617211338.GA24771@alinoe.com>
	 <20070617213355.GC3430@redhat.com> <20070617223649.GA31587@alinoe.com>
	 <20070617224918.GC12483@redhat.com> <20070618000643.GA1375@alinoe.com>
	 <20070618001627.GA18598@redhat.com>
	 <21d7e9970706171757n4709383cv7a39a66103edc370@mail.gmail.com>
	 <20070618015636.GA8561@alinoe.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > The thing is here, this is PCIE, so if there is a GPU plugged into the
> > PCIE 16x slot in theory the main onboard graphics should disable, AGP
> > code is used to control the GART for the onboard chip, in this case a
> > plugged in card will  not use AGP, I wonder have Intel tested with a
> > pcie card in place...
>
> That is Chinese for me :/.
> Do you want me to try something?
>

Well it was more for davej's benefit, in theory for your machine with
a PCIE graphics card you don't need agpgart enabled at all granted it
shouldn't screw up if it is..

Dave.
