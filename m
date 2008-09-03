Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbYICI2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbYICI2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 04:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYICI21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 04:28:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:62776 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbYICI20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 04:28:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WG4ranLJeMr05DZgOL77/fmfv+t3DcHwt4/sryauYL4pinvBPe+8RbPPFEQC9VajIP
         OFuwlMT7CVP9+7BT8kgztk1QGYzxmT+YIGcJCXFz6h1KzskbVykJ0dD1am1h1aG/da7x
         8rs58K6kBdj30s0IjgxFtQxFGNR5MI5XVEPAo=
Message-ID: <68676e00809030128o45820023n6f270847e14af2a3@mail.gmail.com>
Date: Wed, 3 Sep 2008 10:28:25 +0200
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [2.6.27] early exception - lockdep related?
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
In-Reply-To: <1220424721.8609.74.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080902210646.GA10925@dreamland.darkstar.lan>
	 <1220424721.8609.74.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 3, 2008 at 8:52 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2008-09-02 at 23:06 +0200, Luca Tettamanti wrote:
>> Hello,
>> I'm seeing an early exception (0e) - which seems related to lockdep - at
>> boot with many 2.6.27 kernels and I'm having troubles to track it down.
>
> Does it print one of these nice stack traces?

Of course not ;-) It dies before dumping the stack trace (or at least
it doesn't make to the console - that machine has a serial port, but
my notebook does not... I've ordered a usb-to-serial adapter).

>> The strange thing is that it comes and goes with different kernel
>> versions
>
> What kernel version did you generate the below with - and what config.

-rc2 is working, after that it's intermittent. The last kernel that I
tried is -git from a couple of days ago.

>> , but a "bad" kernel consistently fails across reboots. It also
>> seems to be sensitive to the configuration (attached)
>
> you seem to have forgotten that attachment.

Ops, will send as soon as I get home.

Luca
