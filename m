Return-Path: <linux-kernel-owner+w=401wt.eu-S1760819AbYEFNKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760819AbYEFNKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 09:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbYEFNJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 09:09:59 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:60265 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbYEFNJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 09:09:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ZEL9EVEohJM78eFG36awn2oE73X0XPetZfQAt492sHF578LhxQD+VCCcfnNL8eTyMrO/5zuLZRZYQ0opxGUh2OSzWygQ8/A6ELD1WYfMbLnVOjeIdc2X9zoTaFNVcEDysF/h2f5GfVu+d0X4VoBbBplSA8sxRDKs6Uk4x186coo=
Message-ID: <17896ec80805060609n77a5b5dyfbb2a4a5dff99acb@mail.gmail.com>
Date: Tue, 6 May 2008 15:09:50 +0200
From: "Mile Davidovic" <md4linux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Remaping page range
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specific problem.
for recovery reasons I need to keep current mmaping in user space, but
to force Kernel to invalidate pages assigned to given file descriptor.
I tried wild-guess  with 'zap_page_range' and
'invalidate_inode_pages'.... does not work.

Is there already way to remove all pages linked to specific inode?

Something like 'do_mremap' will be perfect, only if I can overlap old
and new address....

Thanks in advance
