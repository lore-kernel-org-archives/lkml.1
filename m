Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbYJHTk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbYJHTk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbYJHTko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:40:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:1894 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbYJHTkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:40:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bqPYiaLbX6kRGys7OjXC1gqf3r87o9wId7CZE/4Zaxp8Kw9Cx8KWOFsjEKiaPtrNpw
         Ajp3R2dmjY2gfjT05j3oiuFOzQi2oUcGYF1xdagOzeEq4xqqVQ+bMdkH8ajm3O+1ddKA
         j5qp7U/6k/HSyu3ZnEVqZc7uSeCimtjTkg3NU=
From: "Richard A. Holden III" <aciddeath@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Richard A. Holden III" <aciddeath@gmail.com>, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 00/10] ixj: Cleanup dead and duplicate code
Date: Wed,  8 Oct 2008 14:41:35 -0600
Message-Id: <cover.1223497216.git.aciddeath@gmail.com>
X-Mailer: git-send-email 1.5.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup dead code and duplicate code to start simplifying the ixj
driver, currently it is around 10000 lines long. This has been built,
but I don't have the hardware to test, most changes were fairly
mechanical.

Richard A. Holden III (10):
  ixj: Remove code duplication for processing codec names.
  ixj: Remove dead code in preparation for consolidating duplicate
    code.
  ixj: Unify comments in preparation for pushing duplicate code into a
    function.
  ixj: Consolidate duplicate Ringer array initializers into common
    functions.
  ixj: Move duplicate code into well named zero_caller_id function.
  ixj: Caller ID Refactoring
  ixj: Refactor DTMF tone setting
  ixj: update quickly readable comments to match the data initializations.
  ixj: Remove unused macro.
  ixj: Remove dead code from ifdef IXJ_DYN_ALLOC.

 drivers/telephony/ixj.c |  752 +++++++++++------------------------------------
 drivers/telephony/ixj.h |    4 -
 2 files changed, 166 insertions(+), 590 deletions(-)

