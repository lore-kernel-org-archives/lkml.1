Return-Path: <linux-kernel-owner+w=401wt.eu-S1766602AbXEDUjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766602AbXEDUjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 16:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766611AbXEDUjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 16:39:23 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:14486 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766602AbXEDUjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 16:39:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=WendJpeezIVmk6xC2YtFGRZ+VGPNUBsFeZGeTLuqcMwv4DfFjqd765iEtTxjXvlXq1Hy5kUkr7+NxcDjtXnwj+JfQN+fPvmgjO5sJCuVhrhUNbJ4xcAtLEF9WnBCFOBV+/EmJcINKzHPi+L3lnTwkvolJeF0KA4yD4PiIrfAPHg=
Message-ID: <463B99EE.2090001@gmail.com>
Date: Fri, 04 May 2007 22:39:10 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Phillip Susi <psusi@cfl.rr.com>
CC: Francesco Pretto <ceztko@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no>  <fa.YHt2nIlQmoW5r2enmTSzsaySwH4@ifi.uio.no> <45DD0348.5040005@shaw.ca> <e5ab0f710702231235ucb559eerb3639ec312aa312a@mail.gmail.com> <463B858E.6060002@cfl.rr.com>
In-Reply-To: <463B858E.6060002@cfl.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> Did anything ever come of this?  We still have users complaining about
> this.  Does this patch resolve the issue?  I can't seem to load it up
> right now; the site says it is down for maintenance.

Yeap, the third iteration of the patch just got submitted.

  http://thread.gmane.org/gmane.linux.ide/18485

Unfortunately, there doesn't seem to be an easy way out.  We'll need
userland shutdown(8) update.

-- 
tejun
