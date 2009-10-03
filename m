Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbZJCKV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbZJCKV2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 06:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbZJCKV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 06:21:27 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:58569 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbZJCKV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 06:21:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Uz6J3OFjQgsb3Z6VaELFg1C8JJ7pl2jDaEVxSYTEBuUZhRMRV+N+XVpq8ZGu+d7KrY
         AsYP7edXc1oJp+zg/AmBB4khS7MptuNX6railPdUr04H0m5Bs8KgeZaYttaKlnAasmtZ
         sN7AGrXrnCIYHazLbrv3l6xh2mxNdb8FUwPBM=
Date: Sat, 3 Oct 2009 12:21:25 +0200
From: Johan Hovold <jhovold@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Johan Hovold <jhovold@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Message-ID: <20091003102125.GA605@localhost>
References: <200909242103.48562.oliver@neukum.org>
 <20090924202107.4730f2af@lxorguk.ukuu.org.uk>
 <20090924211459.GB27963@localhost>
 <4ABD020B.4040901@gandalf.sssup.it>
 <20090929145514.GF2152@localhost>
 <20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
 <m163ayzevu.fsf@fess.ebiederm.org>
 <20091002084755.GA7382@localhost>
 <20091002173308.6158d734@lxorguk.ukuu.org.uk>
 <m11vllxwd7.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11vllxwd7.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 03:29:56PM -0700, Eric W. Biederman wrote:
> The code doesn't fall over immediately in my testing.  So at first glance
> this appears to be as good as removing low_latency.

The patch wasn't intended as a replacement for removing low_latency. It
still calls tty_flip_buffer_push from interrupt context.

/Johan

