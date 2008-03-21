Return-Path: <linux-kernel-owner+w=401wt.eu-S1761306AbYCUACs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761306AbYCUACs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 20:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759138AbYCTX5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:57:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:61901 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347AbYCTX43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:56:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=CG4ge3xKePmVh0UKnfts3iflDutY9+ZfWwMmDeUv8xM5J/vLFgb5bH/7YamiLaz9Mkfmn0IRkN1sjhbHYX3No5EyyeuEd35HrhWFn/ALGjZQZqmCAbRFwl13p9I45atQzn6nCu1YwqX+cHBCOm/K1lox+qoHcliSf8kuKnva7Gg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 05/17] ide-tape: remove pipeline-specific code in idetape_space_over_filemarks()
Date: Fri, 21 Mar 2008 01:09:23 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com> <1205736090-4435-6-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1205736090-4435-6-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803210109.23513.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008, Borislav Petkov wrote:
> Since we don't do pipeline read-ahead anymore, we don't have to look for
> filemarks we have crossed. Therefore, remove the code chunk that does that and
> pass on the command to the tape. As a side effect, remove unused
> idetape_wait_first_stage().
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
