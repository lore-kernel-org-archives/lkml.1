Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbYFLRFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbYFLRFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbYFLRF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:05:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:27268 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbYFLRF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:05:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ISHyHhwiINIwJkhOw470oid9xn5gjh462z4Q5DIvyJtcLncJNiUej9rpyqj7YR8uoF
         BHqU6W2CJLQwZgb8ClMg4m4u8ko15fD/bb/4PPyrO9H4+D0viYV08geOiIz/AtCKVCom
         qpyW/5+fIM2tpyNHf5fLtE0fWfIDAQKNkWEDk=
Message-ID: <86802c440806121005g42f2e44cxbe5f7bdb06836a1e@mail.gmail.com>
Date: Thu, 12 Jun 2008 10:05:27 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: Confusions with reserve_early, reserve_bootmem, e820, efi, ... on x86_64
Cc: mingo@elte.hu, bwalle@suse.de, hannes@saeurebad.de, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, steiner@sgi.com
In-Reply-To: <20080612111943.c140c4cb.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080612050609.88a8cf7f.pj@sgi.com>
	 <86802c440806120525v2da860bfyf05eb8ec6b9943d0@mail.gmail.com>
	 <20080612111943.c140c4cb.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 9:19 AM, Paul Jackson <pj@sgi.com> wrote:
> Yinghai wrote:
>> then reserve_ebda_region() need to be fixed.
>
> What do you have in mind here?
>
that function seems to increase the ebda to workaround some broken
machine blindly.

YH
