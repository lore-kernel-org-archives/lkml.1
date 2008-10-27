Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbYJ0Tbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbYJ0Tbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbYJ0Tbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:31:40 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:2260 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbYJ0Tbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:31:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=d1kjaawB8oGwxnLA/cCynKsKbatTIAHVn44fkJdn7wujH1I1+zA+xA2bxH+S0NNp6x
         c1zhkRG9US854u/wi+SIjskfnbvPqKaX+RhWEpTnqBK1wKBN/3ixd/J5Awxm243Db9AY
         wKu82Bd8hDirJtliW2N0/JFN20GV3pafTS3qc=
Subject: Re: [PATCH] ibmpex: trivial endian annotation in extract_data
 helper
From: Harvey Harrison <harvey.harrison@gmail.com>
To: djwong@us.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081027183209.GU7771@tree.beaverton.ibm.com>
References: <1224891898.5784.0.camel@brick>
	 <20081027183209.GU7771@tree.beaverton.ibm.com>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 12:26:06 -0700
Message-Id: <1225135566.5396.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 11:32 -0700, Darrick J. Wong wrote:
> On Fri, Oct 24, 2008 at 04:44:58PM -0700, Harvey Harrison wrote:
> > This helper is used in few enough locations that open-coding it
> > at the call sites may be better than the helper.
> 
> I'm not sure how this comment relates to the diff.
> 

I was referring to the extract_data helper inline, it's only used ~5
times and doesn't add much (IMO) over just opencoding it.

Cheers,

Harvey

