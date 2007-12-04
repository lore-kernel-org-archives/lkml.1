Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbXLDUbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbXLDUbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXLDUbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:31:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:29809 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbXLDUbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:31:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=U0JFnFT7n/6jNFcYZvO3K/+ozYWmLkiOMZDvUcyg5fx41R2Qsg1yObZFtcyJ12gaq+p0r/Vxf3QKFe9bF0E+25Z054rOEzOR0pcPiv3YWu+krH2HGL1agw7q1vFhP0rdBwsbbHvVuGO9H0B6OsyHXVCS1RKGLTaxA0WgOaGEay4=
Date: Tue, 4 Dec 2007 21:31:32 +0100
To: rjw@sisk.pl
Cc: linux-main <linux-kernel@vger.kernel.org>
Subject: Suspend order
Message-Id: <20071204213132.d806a24f.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey rafael,

For obvious reasons it would be great to have serial output to be the last to enter suspend, thus giving every last drop of debugging
before actually turning the machine "off".

I'm not aware of any specific order currently, from what I've seen currently  every driver is asked to go into suspend at the same time. This of course providing driver x isn't dependant on driver y. You following?

So, without digging to much into this, is there any specific order?

Best wishes
Kristoffer
