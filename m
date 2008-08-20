Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbYHTRN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbYHTRN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 13:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbYHTRNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 13:13:18 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:61657 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbYHTRNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mgqMYN+z7zFEpEOEKZu6sZji8CtufqF5SLEisjiLunVBMZXxQNHysrroGJuh59XINy
         Bbkq3jQ07CrYCSVFVE+IJnQWLTWHp5SObYAjeJwXaPpnt9bJ/XKnL7gpwq6LNTqdvj5F
         55GaT4nqlnAcf4gxAfuCPWtV79Y3GrNvV4WA8=
Subject: Re: [PATCH 1/2] byteorder: add new headers for make headers-install
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1219241454.2988.155.camel@pmac.infradead.org>
References: <1219091880.23637.5.camel@brick>
	 <1219241454.2988.155.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 10:13:14 -0700
Message-Id: <1219252394.6115.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-20 at 15:10 +0100, David Woodhouse wrote:
> On Mon, 2008-08-18 at 13:38 -0700, Harvey Harrison wrote:
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> > Andrew, two fixes before the arches start moving over.
> 
> We don't expose cpu_to_le32() et al., do we? Only __cpu_to_le32() and
> similar? Which exported headers use these -- and are they actually using
> the __ versions? If not, they're not going to work anyway, are they?
> 

Correct, the cpu_to_le32(), etc are wrapped in #ifdef KERNEL, but this adds
the export for the two new headers that will replace the byteorder/*.h
implementation.

Once each arch has moved over, include/linux/byteorder/* will go away.

Cheers,

Harvey

