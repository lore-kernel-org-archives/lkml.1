Return-Path: <linux-kernel-owner+w=401wt.eu-S1758681AbYAaOed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681AbYAaOed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 09:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYAaOeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 09:34:24 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:63557 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbYAaOeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 09:34:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Qz42mnNLmDDqSxPsER/d1HoMwgx7l2Z79xPbZbjE0T4StWw75WhqWdITffZx/WaHHt1ZrvNfST+8zfU/WogaK4XMCIzciVltO58XUfo2oWSgx6xZbDKtwicYydTEgEJre/+xPBKx8uKbX6y/FizmQmhNhMX1Eq1oyC7Z6l640ts=
Message-ID: <e2e108260801310634n21473909o5abac021cc889de3@mail.gmail.com>
Date: Thu, 31 Jan 2008 15:34:17 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Cc: "FUJITA Tomonori" <tomof@acm.org>, fujita.tomonori@lab.ntt.co.jp,
       rdreier@cisco.com, James.Bottomley@hansenpartnership.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <1201785938.7280.105.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <20080130195635T.tomof@acm.org>
	 <1201785938.7280.105.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 31, 2008 2:25 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> Since this particular code is located in a non-data path critical
> section, the kernel vs. user discussion is a wash.  If we are talking
> about data path, yes, the relevance of DD tests in kernel designs are
> suspect :p.  For those IB testers who are interested, perhaps having a
> look with disktest from the Linux Test Project would give a better
> comparision between the two implementations on a RDMA capable fabric
> like IB for best case performance.  I think everyone is interested in
> seeing just how much data path overhead exists between userspace and
> kernel space in typical and heavy workloads, if if this overhead can be
> minimized to make userspace a better option for some of this very
> complex code.

I can run disktest on the same setups I ran dd on. This will take some
time however.

Disktest is new to me -- any hints with regard to suitable
combinations of command line parameters are welcome. The most recent
version I could find on http://ltp.sourceforge.net/ is ltp-20071231.

Bart Van Assche.
