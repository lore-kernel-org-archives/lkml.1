Return-Path: <linux-kernel-owner+w=401wt.eu-S1759827AbYAaOpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827AbYAaOpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 09:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbYAaOox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 09:44:53 -0500
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:48368 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751786AbYAaOow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 09:44:52 -0500
X-YMail-OSG: QSusd7oVM1kJwp7IHLdfoyTw99xlX7LNDyHgKgjFqlxn.GegIMcrNu8rRy2tIIc.aNyo4i0FiIvo6Ov3gWQGMDGp2Zhd_sa2yzHcDzsLnB9hSpX2EYM-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: Integration of SCST in the mainstream Linux kernel
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: FUJITA Tomonori <tomof@acm.org>, fujita.tomonori@lab.ntt.co.jp,
       rdreier@cisco.com, James.Bottomley@hansenpartnership.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <e2e108260801310634n21473909o5abac021cc889de3@mail.gmail.com>
References: <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <20080130195635T.tomof@acm.org>
	 <1201785938.7280.105.camel@haakon2.linux-iscsi.org>
	 <e2e108260801310634n21473909o5abac021cc889de3@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 06:44:23 -0800
Message-Id: <1201790663.11265.34.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

On Thu, 2008-01-31 at 15:34 +0100, Bart Van Assche wrote:
> On Jan 31, 2008 2:25 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> > Since this particular code is located in a non-data path critical
> > section, the kernel vs. user discussion is a wash.  If we are talking
> > about data path, yes, the relevance of DD tests in kernel designs are
> > suspect :p.  For those IB testers who are interested, perhaps having a
> > look with disktest from the Linux Test Project would give a better
> > comparision between the two implementations on a RDMA capable fabric
> > like IB for best case performance.  I think everyone is interested in
> > seeing just how much data path overhead exists between userspace and
> > kernel space in typical and heavy workloads, if if this overhead can be
> > minimized to make userspace a better option for some of this very
> > complex code.
> 
> I can run disktest on the same setups I ran dd on. This will take some
> time however.
> 
> Disktest is new to me -- any hints with regard to suitable
> combinations of command line parameters are welcome. The most recent
> version I could find on http://ltp.sourceforge.net/ is ltp-20071231.
> 

I posted some numbers with traditional iSCSI on Neterion Xframe I 10
Gb/sec with LRO back in 2005 with disktest on the 1st generation x86_64
hardware available at the time.  These tests where designed to show the
performance advantages of internexus multiplexing that is available
within traditional iSCSI, as well as iSER.

The disktest parameters that I used are listed in the following thread:

https://www.redhat.com/archives/dm-devel/2005-April/msg00013.html

--nab

> Bart Van Assche.
> 

