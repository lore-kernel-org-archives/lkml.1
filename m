Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbYFXGq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbYFXGq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 02:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYFXGqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 02:46:13 -0400
Received: from ag-out-0708.google.com ([72.14.246.240]:29132 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYFXGqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 02:46:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=hvReD5hQD7yX4hAsK37uChDu3gOPdXUzbK5/On+2i6QZjY1XxgySYB8CA6i9+CSj56
         qnh0JaXd/CXzUT++qmn9HOCwEuOjewVYi2ZQpNnELMvswoNMlt5WPAwqKniueuAuCih3
         CcbMSMZWuz3mr92YGEvKqbi8mphu3zOWK3jWQ=
Message-ID: <c058f1520806232346q5c963083x214b658e85523d95@mail.gmail.com>
Date: Mon, 23 Jun 2008 23:46:11 -0700
From: "X Jin" <jinx080808@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: PCM format support (24 bit data stored in 32-bit word) in ALSA?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a capture card using a TI PCM1803a chip, which is a 24-bit AD
converter. However a 24-bit digital information is stored in a 32-bit
word. I searched the ALSA PCM code and found that the format
SNDRV_PCM_FORMAT_S24_LE (and others) defines the physical bit width as
32. I guess these definitions are designed to handle exactly the
situation I'm facing now. In other words, ALSA can handle the 24-bit
format in a 32-bit physical data.

Is my understanding correct?

TIA
-XJ
