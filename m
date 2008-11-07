Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbYKGKrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbYKGKrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 05:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbYKGKrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 05:47:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:17060 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYKGKrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 05:47:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XatuXSKAlfYLM1l0hegm3GOOYVvf/r2vH1ZslpXPwGpzIt0dKavuqfnY+ysLQyyBZO
         +HUJD1cjVZmEplF13LRk168rJUJP+49GjgqeaT3jpmW/5Q8al/CsohF9FUt+diMSNTOj
         OWDr2hfWygYOKrL0Yb1c7z7+Lnx4Drul8jNdA=
Message-ID: <e2e108260811070247h11992d74p3ad0786cd4523dc0@mail.gmail.com>
Date: Fri, 7 Nov 2008 11:47:09 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Michael Dressel" <Michael.Dressel@bruker-biospin.de>
Subject: Re: pthread_mutex_lock hangs on unlocked mutex
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LSU.2.00.0811070856260.5231@eleven.esr.bruker.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LSU.2.00.0811070856260.5231@eleven.esr.bruker.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2008 at 9:43 AM, Michael Dressel
<Michael.Dressel@bruker-biospin.de> wrote:
> in our software three processes are using several pthread mutexes.

LKML is a mailing list to discuss kernel issues. What you report is
most likely a userspace issue. Please check your application with the
Valgrind tools memcheck, helgrind and/or drd first.

Bart.
