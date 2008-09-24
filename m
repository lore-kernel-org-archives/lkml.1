Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbYIXWzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbYIXWzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 18:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYIXWyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 18:54:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:63222 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbYIXWyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 18:54:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AhwAGFEK2DUUTL/f/J6G2zBKnQ2vC87TMjkYiNzyGSbyvS1BAEElMqZSA1M5Yjden6
         7YzovRLv+FgB9w3oIJrcbifcxo9XkDyUmJfs/yxowa9j8oq3W+wo5vLf8vLCF9wR3TT0
         zvtdvxf3EuxvDVyvn2aLeFHYZjHDqEJooNyQA=
Message-ID: <f7848160809241554n44efa90bldfc656eda2cab66a@mail.gmail.com>
Date: Wed, 24 Sep 2008 18:54:53 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Cc: "Dave Airlie" <airlied@gmail.com>, "David Miller" <davem@davemloft.net>,
       jeffrey.t.kirsher@intel.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com
In-Reply-To: <alpine.LNX.1.10.0809241829500.4671@pegasus.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21d7e9970809232245x6a91c6e2l552ff039d07e2017@mail.gmail.com>
	 <20080924.003638.71148740.davem@davemloft.net>
	 <21d7e9970809240159u6db747eex51892061846b2251@mail.gmail.com>
	 <20080924.020116.193720569.davem@davemloft.net>
	 <21d7e9970809240216m4a93a339sb51a5928fcb5f6fb@mail.gmail.com>
	 <alpine.LNX.1.10.0809241829500.4671@pegasus.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 12:33 PM, Jiri Kosina <jkosina@suse.cz> wrote:

> Actually another user has just reported [1] that his e1000e card got
> screwed up exactly at the point when the installer was probing the X
> configuration. So this really seems a lot like some lethal interaction
> between intel graphics and the network card.
>

Another data point in the support of this theory - I've been running
all various 2.6.27-rc releases (including rc7) on my HP machine which
has an embedded 82566 and Radeon x1650 graphics - and so far I have
not seen any problems.

Parag
