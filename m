Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZBQMVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZBQMVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 07:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZBQMVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 07:21:00 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:55436 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbZBQMU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 07:20:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wo2gywytC/P7iN2M2Y7QuKpf6LmF2mAUeb7MqMGjbfDLlijyQwgDxSSw5ro34ad2BZ
         fsINi0SnKhdj7fiuVych67XJvA1Y+N3DNdJVZQf9oObMko6iD6hWdx5ZsIEN7qm4gDdb
         OeMWTUnJ2+qwhpSfcdBzpoPIg/hIIt52D9uPs=
Date: Tue, 17 Feb 2009 12:20:52 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Karl Hiramoto <karl@hiramoto.org>
Cc: netdev@vger.kernel.org, netfilter@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: problem with IPoA (CLIP),  NAT, and VLANS
Message-ID: <20090217122052.GB6130@ff.dom.local>
References: <20090216232016.GA4803@ami.dom.local> <499AA433.8070308@hiramoto.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499AA433.8070308@hiramoto.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 12:49:07PM +0100, Karl Hiramoto wrote:
...
> A side note:  so far the original patch i sent works in all cases i have
> tested, but fails with tcpdump.   I suspect its because the skb gets cloned.

If there is something readable from this tcpdump, it should be helpful
to see a packet for working and non-working case during such ping
(with -nXX option).

Jarek P.
