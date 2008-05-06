Return-Path: <linux-kernel-owner+w=401wt.eu-S1765207AbYEFRFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765207AbYEFRFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758500AbYEFRFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:05:30 -0400
Received: from outbound-mail-156.bluehost.com ([67.222.39.36]:51852 "HELO
	outbound-mail-156.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759252AbYEFRF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:05:29 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: kgdboe?
Date: Tue, 6 May 2008 10:05:13 -0700
User-Agent: KMail/1.9.9
Cc: Jason Wessel <jason.wessel@windriver.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Christoph Hellwig <hch@infradead.org>
References: <481EFE69.20308@windriver.com> <200805051110.32238.jbarnes@virtuousgeek.org> <20080506131632.GD2146@elte.hu>
In-Reply-To: <20080506131632.GD2146@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805061005.13669.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 06, 2008 6:16 am Ingo Molnar wrote:
> * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > So when will we see kgdboe or some other way of getting gdb to connect
> > to the target over ethernet upstream?
>
> i think the proper way would be to extend the kgdb-over-console (kgdboc)
> concept and make it easy to utilize the existing netconsole code via
> KGDB. This brings nice synergy: netconsole is utilized by other debug
> infrastructure as well so anything that supports netconsole would
> automatically support KGDB as well. I dont really like the old kgdboe
> approach from a design POV as it created a parallel infrastructure for
> special-purpose kgdb IO.

When I looked at the sources right after it was merged this seemed like the 
preferred approach, but I couldn't find any evidence of anyone working on the 
port...  Are you aware of any?

Jesse
