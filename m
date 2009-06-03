Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbZFCNMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbZFCNMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 09:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbZFCNM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 09:12:28 -0400
Received: from easi.embeddedalley.com ([71.6.201.124]:33963 "HELO
	easi.embeddedalley.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753563AbZFCNM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 09:12:28 -0400
Subject: Re: linux-next: ubi tree build failure
From: dmitry pervushin <dpervushin@embeddedalley.com>
Reply-To: dpervushin@embeddedalley.com
To: Artem.Bityutskiy@nokia.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A2672A8.8020809@nokia.com>
References: <20090603184408.49c7fb1f.sfr@canb.auug.org.au>
	 <4A265DF6.3070602@nokia.com>  <4A2672A8.8020809@nokia.com>
Content-Type: text/plain
Organization: EmbeddedAlley
Date: Wed, 03 Jun 2009 17:05:43 +0400
Message-Id: <1244034343.4074.2.camel@hp.diimka.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-03 at 15:55 +0300, Artem Bityutskiy wrote:
> Did not see compile error on x86 as well. Anyway, I have added more
> includes which seem to be missed. Hopefully this problem is fixed
> now. Thanks!
however it builds ok on arm too, adding #include <linux/err.h> should
fix this..


